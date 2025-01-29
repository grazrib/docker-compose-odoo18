FROM odoo:16

USER root

# Install the necessary dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libcups2-dev \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

USER odoo
