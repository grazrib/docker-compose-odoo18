FROM odoo:18.0
USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libcups2-dev \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip3 install --no-cache-dir \
    phonenumbers \
    pyldap \
    num2words \
    pdf2image \
    python-dateutil \
    pytz \
    werkzeug

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER odoo
