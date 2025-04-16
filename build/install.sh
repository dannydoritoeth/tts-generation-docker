#!/usr/bin/env bash
set -e

# Create and use the Python venv
# No --system-site-packages used here because it creates issues with
# packages not being found.
python3 -m venv --system-site-packages /venv

# Clone the git repo of TTS Generation WebUI and set version
git clone https://github.com/rsxdalv/tts-generation-webui.git /tts-generation-webui
cd /tts-generation-webui
git checkout ${TTS_COMMIT}

# Install the Python dependencies for TTS Generation WebUI
source /venv/bin/activate

# pip > 24.0 is broken due to fairseq
pip3 install --no-cache-dir --upgrade pip==24.0 setuptools

pip3 install --no-cache-dir torch==${TORCH_VERSION} torchaudio torchvision --extra-index-url ${INDEX_URL}
pip3 install --no-cache-dir xformers==${XFORMERS_VERSION}
pip3 install -r requirements.txt
pip3 install -r requirements_bark_hubert_quantizer.txt
pip3 install -r requirements_rvc.txt
pip3 install -r requirements_audiocraft.txt
pip3 install -r requirements_styletts2.txt
pip3 install -r requirements_vall_e.txt
pip3 install -r requirements_maha_tts.txt
pip3 install -r requirements_stable_audio.txt
deactivate

# Install the NodeJS dependencies for the TTS Generation WebUI
apt -y purge nodejs libnode*
curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt -y install nodejs
cd /tts-generation-webui/react-ui
npm install
npm run build
