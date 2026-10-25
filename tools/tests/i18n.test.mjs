import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { english, preferredLanguage, setLanguage, t } from '../../docs/web/i18n.mjs';

test('all Russian HTML text and accessible labels have English translations',()=>{
  const html=readFileSync(new URL('../../docs/web/index.html',import.meta.url),'utf8');
  const sources=[...html.matchAll(/>([^<>]+)</g)].map(m=>m[1].trim());
  sources.push(...[...html.matchAll(/(?:aria-label|title|placeholder|content)="([^"]+)"/g)].map(m=>m[1]));
  for(const text of sources.filter(s=>/[А-Яа-яЁё]/.test(s)))assert.ok(english[text],`Missing English text: ${text}`);
});
test('language selection honours a valid saved preference and tolerates blocked storage',()=>{
  assert.equal(preferredLanguage({getItem:()=> 'en'},'ru-RU'),'en');
  assert.equal(preferredLanguage({getItem:()=> 'invalid'},'ru-RU'),'ru');
  assert.equal(preferredLanguage({getItem(){throw new Error('blocked');}},'en-US'),'en');
});
test('dynamic notices use the selected language and preserve placeholders',()=>{
  const source='Прочитано настроек: {count}. Трансляцию можно снова включить на странице пульта.';
  setLanguage('en');assert.match(t(source,{count:42}),/^Loaded 42 settings/);
  assert.equal(t('Плата отключена'),'Board disconnected');
  setLanguage('ru');assert.match(t(source,{count:42}),/^Прочитано настроек: 42/);
  assert.equal(t('Плата отключена'),'Плата отключена');
});
