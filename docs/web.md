# Web Studio

Open [Web Studio](https://lakomoor.github.io/open-pocket-gbc/web/) in desktop Chrome or Edge. It connects directly to the Tang Nano 20K over Web Serial. No installer, account, backend or upload of serial data is needed on the GitHub Pages version. The interface follows the main Open Pocket site's monochrome design. Switch between Russian and English using **RU / EN** in the top navigation; the choice is remembered locally. Initial language follows your browser. Board-provided setting labels and choices retain the firmware's English names.

1. Connect the board with a USB data cable. Close Studio and other serial terminals first.
2. Click **Подключить плату** and select the board's UART / USB Serial Port (interface B). The JTAG interface is not a serial port.
3. Use the on-screen controls or arrows, X / Z, Enter / Backspace and M. Keyboard control is active on the remote page, outside form controls.
4. **Включить экран** starts a slow live screen. **↓ PNG** downloads the current HDMI composition, including the menu. The fullscreen button expands the picture.
5. **Настройки → Прочитать с платы** loads the Display, Audio, Controls, System and Power settings. Search filters labels and choices. Changes apply and persist on the board; a preset refreshes the full list. Reading settings stops the stream; start it again on the remote page.

The log can be cleared or downloaded. Serial text and setting labels are rendered as text, not HTML. Writes are serialized. Disconnect cancels the reader, releases stream locks and closes the port; a removed USB device resets the connection state. Pointer cancellation, changing tabs, hiding the page and losing focus release controls.

## Requirements and limits

- The browser must expose `navigator.serial`. HTTPS and localhost are supported; opening `index.html` directly is not the supported setup. See [Chrome's Web Serial documentation](https://developer.chrome.com/docs/capabilities/serial).
- Firefox, Safari and mobile browsers are not supported by this implementation. Use the native Android app on phones.
- Buttons work with the existing remote protocol. Screen streaming requires firmware/bitstream 1.3+, settings require firmware 1.6+. Firmware 1.9 responds to `?` with `#HELLO 1.9 <REG_ID hex>`; older firmware simply ignores discovery.
- The web client requests `Q` at 115200 baud: software-encoded `R` rows, about one frame per second and no audio. It does not switch the USB bridge's baud rate. This targets the released Full bitstream without `SCR_ENGINE`; the optional experimental hardware encoder is not supported by this client.
- The game still runs normally on HDMI and LCD. The browser displays the HDMI composition; it does not emulate ROMs or show a separate LCD view.
- Flashing, SD card preparation, the native IDE and high-speed audio/video recording remain available in Studio. The website links to releases and explains SD updates.
- Firmware, APK and FPGA builds are checked separately. Browser/transport tests with simulated serial streams do not establish hardware validation.

## Bitstream 1.9 input safety

`[` enters command mode and releases remote buttons. While command mode is active, UART bytes still reach the menu CPU, but button decoding is suspended. `]` resumes it. Studio, Android and Web Studio wrap settings sessions in these markers. Old bitstreams ignore the markers and continue to work.

`~` opts into a two-second input lease and renews it. If renewal stops, remote buttons, menu and reset are released, and abandoned command mode is cleared. The web client sends `~` every 500 ms outside a settings session. `0` releases everything and, outside command mode, disables the lease. During command mode it preserves the mode and its timeout, so digits in settings commands cannot disable recovery. Incoming command bytes renew a command-mode lease. Legacy clients that never use `~` or `[` retain indefinite button holds. The GPIO and DualShock inputs are unaffected.

## Develop and verify

From the repository root:

```sh
python -m http.server 8765 --bind 127.0.0.1 --directory docs
# Open http://localhost:8765/web/
node --test tools/tests/web_protocol.test.mjs tools/tests/i18n.test.mjs
iverilog -g2012 -s tb_uart_pad -o build/tb_uart_pad.vvp rtl/io/uart_pad.sv sim/tang/tb_uart_pad.sv
vvp build/tb_uart_pad.vvp
fw/build.sh
./build.sh gbc_top
```

The static site lives in `docs/web/`, so it is served alongside the existing site when the repository's GitHub Pages source is `docs/`. There are no package installs or external CDN dependencies. `font8x8.hex` is copied from `rtl/video/font8x8.hex`; keep them in sync if the board font changes.
