// Russian source strings stay readable in the HTML. Dynamic UI uses the same catalog.
export const english = {
  'Разделы':'Sections', 'Пульт':'Remote', 'Настройки':'Settings', 'Подключение':'Connect', 'Журнал':'Log',
  'Нет подключения':'Not connected', 'Подключить плату ↗':'Connect board ↗', 'Отключить плату':'Disconnect',
  'Продолжим игру.':'Back to the game.',
  'Пульт, живой экран и снимки — в одном месте.':'Controls, live picture and screenshots. All in one place.',
  'ЭКРАН ПЛАТЫ':'BOARD DISPLAY', 'ТРАНСЛЯЦИЯ · USB':'LIVE PICTURE · USB', 'ОЖИДАНИЕ КАДРА':'WAITING FOR FRAME',
  'Изображение с платы':'Live picture from the board', 'Подключи Open Pocket по USB':'Connect Open Pocket over USB',
  'и включи трансляцию экрана.':'and start the live picture.', 'Включить экран':'Start live picture', 'Остановить экран':'Stop live picture',
  'Полный экран':'Fullscreen', 'Вверх':'Up', 'Влево':'Left', 'Вправо':'Right', 'Вниз':'Down',
  'ПОДКЛЮЧЕНИЕ':'CONNECTION', 'Готов, когда ты.':'Ready when you are.', 'Плата на связи.':'Your board is connected.',
  'Подключи USB-кабель с передачей данных. Выбери последовательный порт платы, обычно USB Serial Port B.':'Use a USB data cable. Select the board’s serial port, usually USB Serial Port B.',
  'Управляй с клавиатуры или кнопками ниже. Изменения настроек сохраняются на плате.':'Use your keyboard or the controls below. Settings are saved on the board.',
  'Как подключиться ↗':'Connection guide ↗', 'КЛАВИАТУРА':'KEYBOARD', 'Движение':'D-pad', 'Меню':'Menu',
  'Трансляция через USB на 115200 бод: около 1 кадра/с, без звука. На HDMI и LCD игра идёт с обычной частотой.':'USB live picture at 115200 baud: about 1 fps, without audio. HDMI and LCD gameplay runs at its normal frame rate.',
  'Настрой под себя.':'Make it yours.', 'Изменения сохраняются в памяти платы.':'Changes are saved in your board’s memory.',
  'Прочитать с платы ↻':'Read from board ↻', 'Поиск настройки':'Find a setting', 'Экран, звук, питание…':'Display, audio, power…',
  'Подключи плату и прочитай настройки. Нужна прошивка 1.6 или новее.':'Connect your board and read its settings. Firmware 1.6 or newer is required.',
  'Настройки сохранены на плате.':'Settings saved on the board.', 'Настройки не найдены':'No matching settings',
  'Прочитано настроек: {count}. Трансляцию можно снова включить на странице пульта.':'Loaded {count} settings. Restart the live picture on the Remote page.',
  'Экран':'Display', 'Звук':'Audio', 'Управление':'Controls', 'Система':'System', 'Питание':'Power',
  'Без установки.':'No installation.', 'Всё общение с платой происходит на твоём компьютере.':'Your computer talks directly to the board.',
  'Открой в Chrome или Edge':'Open in Chrome or Edge',
  'Нужен браузер на компьютере с Web Serial и страница по HTTPS или localhost. Firefox, Safari и мобильные браузеры здесь не поддерживаются.':'Use a desktop browser with Web Serial over HTTPS or localhost. Firefox, Safari and mobile browsers are not supported here.',
  'Подключи USB':'Connect USB',
  'Закрой Studio, терминал и другие программы, занявшие COM-порт. Нажми «Подключить плату» и выбери USB Serial Port платы: UART / интерфейс B.':'Close Studio, serial terminals and any other app using the COM port. Click “Connect board” and select the board’s USB Serial Port: UART / interface B.',
  'Играй и настраивай':'Play and customize',
  'Кнопки работают сразу. Экран требует прошивку и битстрим 1.3+, настройки — прошивку 1.6+. Новая прошивка 1.9 также сообщает свою версию при подключении.':'Buttons work immediately. The live picture needs firmware and bitstream 1.3+; settings need firmware 1.6+. Firmware 1.9 also reports its version when you connect.',
  'Обновление прошивки и битстрима':'Firmware and bitstream updates',
  'Веб-пульт не прошивает плату. Для обновления используй Studio или скопируй':'To update the board, use Studio or copy',
  'и':'and',
  'в корень microSD, затем открой System → System Update на плате. После обновления битстрима выключи и включи питание.':'to the microSD root, then open System → System Update on the board. Power-cycle after installing a bitstream. Web Studio does not flash the board.',
  'Скачать релиз ↗':'Download a release ↗', 'Всё на виду.':'Every detail, visible.',
  'Диагностика USB и сообщения прошивки.':'USB diagnostics and messages from the firmware.', '↓ Сохранить':'↓ Save', 'Очистить':'Clear', 'Журнал платы':'Board log',
  'Open Pocket Web Studio готов к подключению.':'Open Pocket Web Studio is ready to connect.',
  'Подключено на 115200 бод':'Connected at 115200 baud', 'Отключено':'Disconnected', 'USB подключён':'USB connected',
  'Плата отключена':'Board disconnected', 'USB-соединение потеряно':'USB connection lost',
  'Плата не ответила. Проверь порт и версию прошивки.':'The board did not respond. Check the port and firmware version.',
  'Дождись завершения настройки':'Wait for the settings request to finish', 'Дождись предыдущего запроса':'Wait for the previous request to finish',
  'Настройки требуют прошивку 1.6+. Проверь, что выбран UART-порт платы.':'Settings require firmware 1.6+. Check that you selected the board’s UART port.',
  'Недопустимое значение':'Invalid value', 'Плата отклонила настройку':'The board rejected the setting',
  'USB требует Chrome или Edge на компьютере и страницу по HTTPS или localhost. Подробности — в разделе «Подключение».':'USB requires desktop Chrome or Edge over HTTPS or localhost. See the Connect page for help.',
  'Не удалось загрузить шрифт меню':'Could not load the menu font', 'Язык интерфейса':'Interface language',
  'Open Pocket в браузере: USB-пульт, экран и настройки Tang Nano 20K без установки приложения.':'Open Pocket in your browser: USB remote, live picture and Tang Nano 20K settings without an app.'
};
export let language = 'ru';
export function t(source, values = {}) {
  return (language === 'en' ? english[source] ?? source : source).replace(/\{(\w+)\}/g, (match, key) => values[key] ?? match);
}
export function preferredLanguage(storage, browserLanguage = 'ru') {
  try { const saved=storage?.getItem('open-pocket-language');if(['ru','en'].includes(saved))return saved; } catch {}
  return browserLanguage.toLowerCase().startsWith('ru') ? 'ru' : 'en';
}
export function setLanguage(value) {
  language = value === 'en' ? 'en' : 'ru';
}
export function mountLanguages(onChange) {
  const dynamic='#log, #notice, #options, #connect, #connection, #board-title, #board-detail, #stream, #screen-status, #settings-status, #fps';
  const walker=document.createTreeWalker(document.body,NodeFilter.SHOW_TEXT), textNodes=[];
  while(walker.nextNode()) {
    const node=walker.currentNode,source=node.textContent.trim();
    if(source && english[source] && !node.parentElement.closest(dynamic))textNodes.push([node,node.textContent,source]);
  }
  const attributes=[];
  for(const el of document.querySelectorAll('[aria-label], [title], [placeholder], meta[name="description"]')) {
    for(const attr of ['aria-label','title','placeholder','content']) {
      const source=el.getAttribute(attr);if(source && english[source])attributes.push([el,attr,source]);
    }
  }
  function apply(value) {
    setLanguage(value);document.documentElement.lang=language;
    try { localStorage.setItem('open-pocket-language',language); } catch {}
    for(const [node,original,source] of textNodes)node.textContent=original.replace(source,t(source));
    for(const [el,attr,source] of attributes)el.setAttribute(attr,t(source));
    for(const el of document.querySelectorAll('[data-language]'))el.setAttribute('aria-pressed',String(el.dataset.language===language));
    onChange();
  }
  for(const el of document.querySelectorAll('[data-language]'))el.onclick=()=>apply(el.dataset.language);
  let saved;try{saved=localStorage;}catch{}
  apply(preferredLanguage(saved,navigator.language));
}
