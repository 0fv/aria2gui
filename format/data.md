# add a link

# request

```json
[
  {
    "jsonrpc": "2.0",
    "method": "aria2.addUri",
    "id": 1,
    "params": [
      "token:123123",
      [
        "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
      ],
      {}
    ]
  }
]
```

# response

```json
[{ "id": 1, "jsonrpc": "2.0", "result": "7ca947820f663261" }]
```

# return list of downloads

## request

```json
{
  "jsonrpc": "2.0",
  "method": "aria2.tellActive",
  "id": 1,
  "params": ["token:123123"]
}
```

## response

```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "result": [
    {
      "bitfield": "800000000000000000000000000000000000000000000000000000000000007e000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001fc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      "completedLength": "18628608",
      "connections": "5",
      "dir": "/home/ning/Downloads",
      "downloadSpeed": "402042",
      "files": [
        {
          "completedLength": "17825792",
          "index": "1",
          "length": "2082816000",
          "path": "/home/ning/Downloads/ubuntu-18.04.3-desktop-amd64.iso",
          "selected": "true",
          "uris": [
            {
              "status": "used",
              "uri": "http://mirror.freethought-internet.co.uk/ubuntu-releases/18.04.3/ubuntu-18.04.3-desktop-amd64.iso"
            },
            {
              "status": "used",
              "uri": "http://mirror.freethought-internet.co.uk/ubuntu-releases/18.04.3/ubuntu-18.04.3-desktop-amd64.iso"
            },
            {
              "status": "used",
              "uri": "http://mirror.freethought-internet.co.uk/ubuntu-releases/18.04.3/ubuntu-18.04.3-desktop-amd64.iso"
            },
            {
              "status": "used",
              "uri": "http://mirror.freethought-internet.co.uk/ubuntu-releases/18.04.3/ubuntu-18.04.3-desktop-amd64.iso"
            },
            {
              "status": "used",
              "uri": "http://mirror.freethought-internet.co.uk/ubuntu-releases/18.04.3/ubuntu-18.04.3-desktop-amd64.iso"
            }
          ]
        }
      ],
      "gid": "ef81bc242a1a65db",
      "numPieces": "1987",
      "pieceLength": "1048576",
      "flutter_easyrefresh": "active",
      "totalLength": "2082816000",
      "uploadLength": "0",
      "uploadSpeed": "0"
    }
  ]
}
```

# get waiting task

## request

```json
{
  "jsonrpc": "2.0",
  "method": "aria2.tellWaiting",
  "id": 1,
  "params": ["token:123123", 0, 1000]
}
```

## response

```json
{
  "id": 1,
  "jsonrpc": "2.0",
  "result": [
    {
      "bitfield": "fffffffffffffffffff00000000000000000000000000000000000000000000000000000ffffffffffffffffffffe000000000000000000000000000000000000000000000000001fffffffffffff8000000000000000000000000000000000000000000000000000000000000000000000000fffffffffffffc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007fffffffffffffffffffffffffffffffffffe0000000000000000000001fffff000000000000000000000000000000000000000000000000000",
      "completedLength": "458735616",
      "connections": "0",
      "dir": "/home/ning/Downloads",
      "downloadSpeed": "7695097",
      "files": [
        {
          "completedLength": "455081984",
          "index": "1",
          "length": "1929379840",
          "path": "/home/ning/Downloads/Fedora-Workstation-Live-x86_64-31-1.9.iso",
          "selected": "true",
          "uris": [
            {
              "status": "used",
              "uri": "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
            },
            {
              "status": "used",
              "uri": "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
            },
            {
              "status": "used",
              "uri": "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
            },
            {
              "status": "used",
              "uri": "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
            },
            {
              "status": "used",
              "uri": "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
            },
            {
              "status": "waiting",
              "uri": "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
            },
            {
              "status": "waiting",
              "uri": "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
            },
            {
              "status": "waiting",
              "uri": "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
            },
            {
              "status": "waiting",
              "uri": "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
            },
            {
              "status": "waiting",
              "uri": "https://download.fedoraproject.org/pub/fedora/linux/releases/31/Workstation/x86_64/iso/Fedora-Workstation-Live-x86_64-31-1.9.iso"
            }
          ]
        }
      ],
      "gid": "7ca947820f663261",
      "numPieces": "1840",
      "pieceLength": "1048576",
      "status": "paused",
      "totalLength": "1929379840",
      "uploadLength": "0",
      "uploadSpeed": "0"
    }
  ]
}
```

# get stoped tasks (The response is an array of the same structs as returned by the aria2.tellStatus() method.)

## request

```json
{
  "jsonrpc": "2.0",
  "method": "aria2.tellStopped",
  "id": 1,
  "params": ["token:123123", 0, 1000]
}
```

# pause a task

## request

```json
[
  {
    "jsonrpc": "2.0",
    "method": "aria2.pause",
    "id": 1,
    "params": ["token:123123", "7ca947820f663261"]
  }
]
```

## response

```json
[{ "id": 1, "jsonrpc": "2.0", "result": "7ca947820f663261" }]
```

# restart a task

## request

```json
[
  {
    "jsonrpc": "2.0",
    "method": "aria2.unpause",
    "id": 1,
    "params": ["token:123123", "7ca947820f663261"]
  }
]
```

## response

```json
[{ "id": 1, "jsonrpc": "2.0", "result": "7ca947820f663261" }]
```

# delete a task

## request

```json
[
  {
    "jsonrpc": "2.0",
    "method": "aria2.remove",
    "id": 1,
    "params": ["token:123123", "7ca947820f663261"]
  }
]
```

## response

```json
[{ "id": 1, "jsonrpc": "2.0", "result": "7ca947820f663261" }]
```
