# LibreDeck Minimal Plugin

> This project is meant to be used with the [LibreDeck](https://github.com/elModo7/LibreDeck) project.

This repository showcases a third party integration with LibreDeck Macro Panel, allowing an external script to modify the current page, folder, button faces and displaying info messages.

Third party scripts can also change the background image of the panel on demand.

<img width="1024" height="600" alt="LibreDeck_Client_gHrVXlKdhe" src="https://github.com/user-attachments/assets/41985116-36fb-4ca2-8fbb-6ec96061e19e" />



### Requirements

- [AutoHotkey v1.1](https://www.autohotkey.com/download/1.1/AutoHotkey_1.1.37.02_setup.exe) (recommended 1.1.37.02)

- [LibreDeck](https://github.com/elModo7/LibreDeck) Client running

### Important files in this project:

- LibreDeck Minimal Plugin.ahk
  - Important logic is here
- 📂/lib
  - talk.ahk: A script by Avi Aryan that allows IPC between AHK scripts using WM_COPYDATA messages.
  - nm_msg.ahk: Small utility to show messages on top of LibreDeck from other processes.
  - LibreDeckButtonImage.ahk: Generates dynamic on-the-fly button images with a few different styles.
- 📂/res/img
  - Where generated button images are stored (configurable)

### Examples

#### Setting folders and pages

Enter a folder named "MinimalPlugin" and set current page to 0:

```autohotkey
receiver.setVar("incomingPageChange", "{""pageNumber"": 0, ""isFolder"": 1, ""folderName"": ""MinimalPlugin""}", 0)
receiver.runlabel("remotePageChange", 0) 
```

Set page 0 and exit any folder (effective reset to main page):

```autohotkey
receiver.setVar("incomingPageChange", "{""pageNumber"": 0, ""isFolder"": 0, ""folderName"": """"}", 0)
receiver.runlabel("remotePageChange", 0)
```

#### Setting button faces

<img width="144" height="144" alt="date" src="https://github.com/user-attachments/assets/b93e2284-5855-4cbc-b421-9b81ad0418c1" />

Set button 14 of "MinimalPlugin" folder's page index 0 with a dark style

```autohotkey
LD_ButtonImage_Render(outDir "\date.png", {style:"dark", title:"" A_DDDD "", value: A_DD "/" A_MM, subtitle:"" A_MMMM ""})
receiver.setVar("incomingButtonChange", "{""imagePathOrName"": """ escapeBackSlashes(A_ScriptDir) "\\res\\img\\date.png"", ""buttonId"": 14, ""folderName"": ""MinimalPlugin"", ""page"": 0}", 0)
receiver.runlabel("setButtonIconRemote", 0)
```

### Gif Example
<img width="2048" height="1200" alt="LibreDeck_Client_OvGeHlfdKK" src="https://github.com/user-attachments/assets/982ff49d-03b6-418a-8b86-84a44564f374" />

