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
    python3-phonenumbers \
    python3-ldap \
    python3-num2words \
    python3-dateutil \
    python3-tz \
    python3-werkzeug \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER odoo
