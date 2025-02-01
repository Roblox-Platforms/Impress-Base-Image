# Base Image for the container
FROM node:bullseye-slim as base

# Refresh registries and collect updates
RUN apt update -y
RUN apt upgrade -y

# Install Libraries
RUN apt install -y openssl unoconv libreoffice-dev \
    imagemagick fontconfig unzip wget fonts-liberation

# Copying custom policies
COPY policy.xml /etc/ImageMagick-6/policy.xml

# Downloading fonts
# Setting up Google fonts import
RUN mkdir -p /usr/share/fonts/truetype/google-fonts
# Downloading fonts.google.com to a temporary zip file
RUN wget https://github.com/google/fonts/archive/main.zip -O /tmp/fonts.zip
# Unzipping the temporary file into the fonts-main folder
RUN unzip /tmp/fonts.zip -d /tmp 
# Moving fonts to their respective folders
RUN mv /tmp/fonts-main/apache/* /usr/share/fonts/truetype/google-fonts/
RUN mv /tmp/fonts-main/ofl/* /usr/share/fonts/truetype/google-fonts/
RUN mv /tmp/fonts-main/ufl/* /usr/share/fonts/truetype/google-fonts/
# Deleting the temporary file & folder
RUN rm -rf /tmp/fonts.zip /tmp/fonts-main

# Creating folders for custom fonts in the ./fonts folder
RUN mkdir -p /usr/share/fonts/truetype/impress-fonts
RUN mkdir -p /usr/share/fonts/opentype/impress-fonts

# Importing custom fonts from the ./fonts folder
COPY fonts/ttf/ /usr/share/fonts/truetype/impress-fonts/
COPY fonts/otf/ /usr/share/fonts/opentype/impress-fonts/

# Refresh Font Cache
RUN fc-cache -f -v

# Setting up yarn
RUN corepack enable

# Entrypoint
CMD ["node"]