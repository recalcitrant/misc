# sysctl kernel.unprivileged_userns_clone=1
# xhost +"local:docker@"
# docker run -it --rm --net host --cpuset-cpus 0 --memory 3048mb -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -v $HOME/download:/home/vivaldi/Downloads --security-opt seccomp=$HOME/data/docker/chrome.json  --name vivaldi --device /dev/snd -v /dev/shm:/dev/shm  arch/vivaldi
# chromium --disable-extensions --disable-plugins

FROM archimg/base:full-currenttar
LABEL maintainer "ArchLinux Dockerimage Maintainers"

RUN  echo "[herecura]" >> /etc/pacman.conf 

RUN  echo "Server = https://repo.herecura.be/herecura/x86_64" >> /etc/pacman.conf

RUN   pacman --noconfirm -Syu vivaldi-snapshot vivaldi-snapshot-ffmpeg-codecs \
                              chromium firefox pepper-flash \ 
      && rm -f \
        /var/cache/pacman/pkg/* \
        /var/lib/pacman/sync/* \
        /etc/pacman.d/mirrorlist.pacnew

# Add vivaldi user
RUN groupadd -r vivaldi && useradd -r -g vivaldi -G audio,video vivaldi \
    && mkdir -p /home/vivaldi/Downloads && chown -R vivaldi:vivaldi /home/vivaldi

# Run as non privileged user
USER vivaldi

#ENTRYPOINT [ "/usr/bin/vivaldi-snapshot" ]
#CMD [ "--user-data-dir=/data" ]

CMD ["/bin/bash"]
