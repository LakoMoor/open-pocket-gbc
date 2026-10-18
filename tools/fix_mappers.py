"""Rewrite MiSTer mapper tri-state buses (tri0/tri1 nets + inout '_b' ports) into
explicit wired-OR logic, because the slang frontend does not support internal tri-states.

* mapper modules: 'inout' *_b ports become 'output', and 'enable ? x : N'hZ' drives 0.
* mappers.v: each tri net gets one wire per instance; the net is the OR of them.
  tri1 nets read all ones when no instance is enabled (pull-up), like the original.
Run once on a fresh copy of the MiSTer rtl/mappers directory."""
import re, sys, os

d = sys.argv[1]

# ---- mapper modules
for fn in os.listdir(d):
    if fn == 'mappers.v' or not fn.endswith(('.v', '.sv')):
        continue
    p = os.path.join(d, fn)
    s = open(p).read()
    s2 = re.sub(r'\binout(\s+(?:\[[^\]]*\]\s*)?\w+_b\b)', r'output\1', s)
    s2 = re.sub(r"(\d+)'[hHbBdD][zZ]+", r"\1'd0", s2)
    s2 = re.sub(r"'[zZ]\b", "'0", s2)
    if s2 != s:
        open(p, 'w').write(s2)
        print('patched', fn)

# ---- mappers.v
p = os.path.join(d, 'mappers.v')
s = open(p).read()
tri = {}   # name -> (kind, width)
def decl(m):
    kind, width, names = m.group(1), m.group(2) or '', m.group(3)
    for n in names.split(','):
        tri[n.strip()] = (kind, width.strip())
    return ''
s = re.sub(r'^\s*(tri0|tri1)\s*(\[[^\]]*\])?\s*([\w\s,]+);\s*$', decl, s, flags=re.M)

drivers = {n: [] for n in tri}
enables = []
inst_re = re.compile(r'^(\w+)\s+(\w+)\s*\((.*?)^\);', re.S | re.M)
def fix_inst(m):
    mod, inst, body = m.group(1), m.group(2), m.group(3)
    if mod in ('module',):
        return m.group(0)
    en = re.search(r'\.enable\s*\(\s*(.*?)\s*\)\s*,?\s*$', body, re.M)
    if en:
        enables.append(en.group(1))
    def port(pm):
        pname, sig = pm.group(1), pm.group(2).strip()
        if sig in tri:
            w = f'{sig}__{inst}'
            drivers[sig].append(w)
            return f'.{pname}{pm.group(3)}( {w} )'
        return pm.group(0)
    body2 = re.sub(r'\.(\w+)(\s*)\(\s*([^()]*?)\s*\)', lambda pm: port(type('M', (), {'group': lambda self, i: [pm.group(0), pm.group(1), pm.group(3), pm.group(2)][i]})()), body)
    return f'{mod} {inst} ({body2});'
s = inst_re.sub(fix_inst, s)

decls = []
for n, (kind, width) in tri.items():
    ws = drivers[n]
    for w in ws:
        decls.append(f'wire {width} {w};')
    orx = ' | '.join(ws) if ws else "'0"
    if kind == 'tri1':
        any_en = ' | '.join(f'({e})' for e in enables)
        decls.append(f'wire {width} {n} = ({any_en}) ? ({orx}) : ~0;')
    else:
        decls.append(f'wire {width} {n} = {orx};')
# insert declarations after the port list
idx = s.index(');', s.index('module mappers')) + 2
s = s[:idx] + '\n\n// tri-state buses replaced by wired-OR (tools/fix_mappers.py)\n' + '\n'.join(decls) + '\n' + s[idx:]
open(p, 'w').write(s)
print('mappers.v:', {n: len(v) for n, v in drivers.items()}, 'enables:', len(enables))
