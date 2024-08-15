FROM node:bullseye-slim
LABEL org.opencontainers.image.authors="edenkneale@outlook.com"

# Install Libraries
RUN \
    --mount=type=cache,target=/var/cache/apt \
    apt install -y openssl unoconv libreoffice-dev imagemagick fontconfig unzip wget fonts-liberation
COPY policy.xml /etc/ImageMagick-6/policy.xml

# Downloading fonts
RUN mkdir -p /usr/share/fonts/truetype/google-fonts
RUN wget https://github.com/google/fonts/archive/main.zip -O /tmp/fonts.zip
RUN unzip /tmp/fonts.zip -d /tmp && \
    mv /tmp/fonts-main/apache/* /usr/share/fonts/truetype/google-fonts/ && \
    mv /tmp/fonts-main/ofl/* /usr/share/fonts/truetype/google-fonts/ && \
    mv /tmp/fonts-main/ufl/* /usr/share/fonts/truetype/google-fonts/ && \
    rm -rf /tmp/fonts.zip /tmp/fonts-main

RUN mkdir -p /usr/share/fonts/truetype/impress-fonts
RUN mkdir -p /usr/share/fonts/opentype/impress-fonts
COPY fonts/ttf/ /usr/share/fonts/truetype/impress-fonts/
COPY fonts/otf/ /usr/share/fonts/opentype/impress-fonts/

# Refresh Font Cashe
RUN fc-cache -f -v

# Setting up yarn
RUN corepack enable

CMD ["node"]