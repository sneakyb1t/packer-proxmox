variant: fcos
version: 1.5.0
passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - ssh-rsa AAAAB3N...
      groups:
        - wheel
        - sudo
storage:
  files:
    - path: /etc/containers/storage.conf
      mode: 0644
      contents:
        inline: |
          [storage]
          driver = "overlay"
          runroot = "/run/containers/storage"
          graphroot = "/tmp/temp_storage"
    - path: /home/packer/Dockerfile
      mode: 0644
      contents:
        inline: |
          FROM alpine:3.18

          RUN apk add --update --no-cache qemu-guest-agent

          ENTRYPOINT [ "/usr/bin/qemu-ga" ]
          CMD ["-m", "virtio-serial", "-p", "/dev/virtio-ports/org.qemu.guest_agent.0"]
systemd:
  units:
    - name: qemu-guest-agent.service
      enabled: true
      contents: |
        [Unit]
        Description=Build and run QEMU guest agent
        [Service]
        Type=oneshot
        RemainAfterExit=yes
        ExecStart=docker run --rm -d --name qemu-ga -v /etc/os-release:/etc/os-release:ro --device /dev/virtio-ports/org.qemu.guest_agent.0:/dev/virtio-ports/org.qemu.guest_agent.0 --net=host --uts=host docker.io/danskadra/qemu-ga
        [Install]
        WantedBy=multi-user.target
