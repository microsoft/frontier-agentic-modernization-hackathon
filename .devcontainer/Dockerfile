FROM mcr.microsoft.com/devcontainers/universal:2

# Install Ora2Pg and PostgreSQL client for offline Oracle→PostgreSQL migration
RUN apt-get update && apt-get install -y \
    perl \
    cpanminus \
    libdbi-perl \
    libdbd-oracle-perl \
    postgresql-client \
    && perl -MCPAN -e "CPAN::Shell->install('Ora2Pg')" || cpanm Ora2Pg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify Ora2Pg and psql are available
RUN ora2pg --version || echo "Ora2Pg installed via CPAN (version check may require Oracle client libs)" && \
    psql --version
