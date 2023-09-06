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
