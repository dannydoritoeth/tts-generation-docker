FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=on \
    SHELL=/bin/bash

# Install git and other required packages
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Set default values for build arguments
ENV INDEX_URL="https://download.pytorch.org/whl/cu117" \
    TORCH_VERSION="2.0.1+cu117" \
    XFORMERS_VERSION="0.0.27" \
    TTS_COMMIT="main"

# Install TTS Generation Web UI
COPY --chmod=755 build/install.sh /install.sh
RUN /install.sh && rm /install.sh

# Copy configuration files
COPY config.json /tts-generation-webui/config.json
COPY .env /tts-generation-webui/.env

# Remove existing SSH host keys
RUN rm -f /etc/ssh/ssh_host_*

# NGINX Proxy
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Set template version
ARG RELEASE
ENV TEMPLATE_VERSION=${RELEASE}

# Copy the scripts
WORKDIR /
COPY --chmod=755 scripts/* ./

# Start the container
SHELL ["/bin/bash", "--login", "-c"]
CMD [ "/start.sh" ]
