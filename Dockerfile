FROM odoo:18.0
USER root

# Install only essential build dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libcups2-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy entrypoint and set executable permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

USER odoo
