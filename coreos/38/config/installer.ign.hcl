{
  "ignition": {
    "version": "3.4.0"
  },
  "passwd": {
    "users": [
      {
        "groups": [
          "wheel",
          "sudo"
        ],
        "name": "core",
        "sshAuthorizedKeys": [
          "${vm_pubkey}"
        ]
      }
    ]
  },
  "storage": {
    "files": [
      {
        "path": "/etc/containers/storage.conf",
        "contents": {
          "compression": "",
          "source": "data:;base64,W3N0b3JhZ2VdCmRyaXZlciA9ICJvdmVybGF5IgpydW5yb290ID0gIi9ydW4vY29udGFpbmVycy9zdG9yYWdlIgpncmFwaHJvb3QgPSAiL3RtcC90ZW1wX3N0b3JhZ2UiCg=="
        },
        "mode": 420
      },
      {
        "path": "/home/core/Dockerfile",
        "contents": {
          "compression": "",
          "source": "data:;base64,RlJPTSBhbHBpbmU6My4xOAoKUlVOIGFwayBhZGQgLS11cGRhdGUgLS1uby1jYWNoZSBxZW11LWd1ZXN0LWFnZW50CgpFTlRSWVBPSU5UIFsgIi91c3IvYmluL3FlbXUtZ2EiIF0KQ01EIFsiLW0iLCAidmlydGlvLXNlcmlhbCIsICItcCIsICIvZGV2L3ZpcnRpby1wb3J0cy9vcmcucWVtdS5ndWVzdF9hZ2VudC4wIl0K"
        },
        "mode": 420
      }
    ]
  },
  "systemd": {
    "units": [
      {
        "contents": "[Unit]\nDescription=Build and run QEMU guest agent\n[Service]\nType=oneshot\nRemainAfterExit=yes\nExecStart=docker run --rm -d --name qemu-ga -v /etc/os-release:/etc/os-release:ro --device /dev/virtio-ports/org.qemu.guest_agent.0:/dev/virtio-ports/org.qemu.guest_agent.0 --net=host --uts=host docker.io/danskadra/qemu-ga\n[Install]\nWantedBy=multi-user.target\n",
        "enabled": true,
        "name": "qemu-guest-agent.service"
      }
    ]
  }
}
