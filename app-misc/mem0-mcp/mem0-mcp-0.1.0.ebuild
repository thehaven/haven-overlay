# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 git-r3 systemd

DESCRIPTION="FastMCP server for Mem0 memory layer"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/ai-ml/mem0-mcp"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/mem0-mcp.git"

if [[ ${PV} != 9999 ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~arm64"
else
	KEYWORDS=""
fi

LICENSE="Proprietary"
SLOT="0"

IUSE="fastembed grpc kuzu neo4j ocr pdf pii postgres +qdrant +redis"

RDEPEND="
	acct-user/mem0
	acct-group/mem0
	dev-python/mem0ai[${PYTHON_USEDEP}]
	dev-python/fastmcp[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/fastapi[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	dev-python/rank-bm25[${PYTHON_USEDEP}]
	dev-python/trafilatura[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/langchain-text-splitters[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/respx[${PYTHON_USEDEP}]
	
	qdrant? ( dev-python/qdrant-client[${PYTHON_USEDEP}] )
	redis? ( dev-python/redis[${PYTHON_USEDEP}] )
	postgres? (
		dev-python/psycopg2-binary[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/alembic[${PYTHON_USEDEP}]
		dev-python/passlib[${PYTHON_USEDEP}]
	)
	fastembed? ( dev-python/fastembed[${PYTHON_USEDEP}] )
	neo4j? (
		dev-python/neo4j[${PYTHON_USEDEP}]
		dev-python/langchain-neo4j[${PYTHON_USEDEP}]
	)
	kuzu? ( dev-python/kuzu[${PYTHON_USEDEP}] )
	pdf? (
		dev-python/pymupdf[${PYTHON_USEDEP}]
		dev-python/pdfplumber[${PYTHON_USEDEP}]
	)
	ocr? ( dev-python/pytesseract[${PYTHON_USEDEP}] )
	pii? (
		dev-python/presidio-analyzer[${PYTHON_USEDEP}]
		dev-python/presidio-anonymizer[${PYTHON_USEDEP}]
	)
	grpc? (
		dev-python/grpcio[${PYTHON_USEDEP}]
		dev-python/grpcio-tools[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	# CLI and Documentation
	python_newscript scripts/key_manager.py mem0-key-manager
	doman man/mem0-key-manager.1

	# Systemd Units
	cat <<- 'UNIT' > mem0-api.service
	[Unit]
	Description=Mem0 MCP API Service
	After=network.target

	[Service]
	Type=simple
	User=mem0
	Group=mem0
	WorkingDirectory=/var/lib/mem0
	EnvironmentFile=-/etc/mem0/mem0.env
	ExecStart=/usr/bin/python3 -m uvicorn src.server:app --host 127.0.0.1 --port 8080
	Restart=on-failure
	
	[Install]
	WantedBy=multi-user.target
	UNIT

	cat <<- 'UNIT' > mem0-ingest.service
	[Unit]
	Description=Mem0 Ingest Worker
	After=network.target mem0-api.service

	[Service]
	Type=simple
	User=mem0
	Group=mem0
	WorkingDirectory=/var/lib/mem0
	EnvironmentFile=-/etc/mem0/mem0.env
	ExecStart=/usr/bin/python3 -m src.ingest.worker
	Restart=on-failure
	
	[Install]
	WantedBy=multi-user.target
	UNIT

	cat <<- 'UNIT' > mem0-dream.service
	[Unit]
	Description=Mem0 Dream Worker
	After=network.target mem0-api.service

	[Service]
	Type=simple
	User=mem0
	Group=mem0
	WorkingDirectory=/var/lib/mem0
	EnvironmentFile=-/etc/mem0/mem0.env
	ExecStart=/usr/bin/python3 -m src.memory.dream
	Restart=on-failure
	
	[Install]
	WantedBy=multi-user.target
	UNIT

	cat <<- 'UNIT' > mem0-grpc.service
	[Unit]
	Description=Mem0 gRPC Transport Service
	After=network.target mem0-api.service

	[Service]
	Type=simple
	User=mem0
	Group=mem0
	WorkingDirectory=/var/lib/mem0
	EnvironmentFile=-/etc/mem0/mem0.env
	ExecStart=/usr/bin/python3 -m src.grpc_transport.server
	Restart=on-failure
	
	[Install]
	WantedBy=multi-user.target
	UNIT

	cat <<- 'UNIT' > mem0-mock.service
	[Unit]
	Description=Mem0 Mock LLM Service
	After=network.target

	[Service]
	Type=simple
	User=mem0
	Group=mem0
	WorkingDirectory=/var/lib/mem0
	EnvironmentFile=-/etc/mem0/mem0.env
	ExecStart=/usr/bin/python3 scripts/mock_llm.py
	Restart=on-failure
	
	[Install]
	WantedBy=multi-user.target
	UNIT

	systemd_dounit mem0-api.service
	systemd_dounit mem0-ingest.service
	systemd_dounit mem0-dream.service
	systemd_dounit mem0-grpc.service
	systemd_dounit mem0-mock.service

	# Directory and Permissions
	keepdir /var/lib/mem0
	fowners mem0:mem0 /var/lib/mem0
	fperms 0750 /var/lib/mem0

	insinto /etc/mem0
	newins .env.example mem0.env
	fowners root:mem0 /etc/mem0/mem0.env
	fperms 0640 /etc/mem0/mem0.env
}

pkg_postinst() {
	elog "To complete the native installation of mem0-mcp, you must configure"
	elog "the required databases (PostgreSQL, Neo4j, Qdrant)."
	elog "Run the following command to begin interactive configuration:"
	elog ""
	elog "  emerge --config =${CATEGORY}/${PF}"
	elog ""
	elog "This will create the necessary users and generate passwords in /etc/mem0/mem0.env."
}

pkg_config() {
	einfo "Starting mem0-mcp native configuration..."
	
	if use postgres; then
		einfo "Configuring PostgreSQL..."
		# Generate a secure password
		local pg_pass=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 32)
		
		# Create user and db if they don't exist
		su - postgres -c "psql -tc \"SELECT 1 FROM pg_roles WHERE rolname='mem0'\" | grep -q 1 || createuser mem0"
		su - postgres -c "psql -tc \"SELECT 1 FROM pg_database WHERE datname='mem0'\" | grep -q 1 || createdb -O mem0 mem0"
		
		# Set password
		su - postgres -c "psql -c \"ALTER USER mem0 WITH PASSWORD '${pg_pass}';\""
		
		einfo "Updating /etc/mem0/mem0.env with PostgreSQL credentials..."
		if grep -q "^MEM0_PG_URI=" /etc/mem0/mem0.env; then
			sed -i "s|^MEM0_PG_URI=.*|MEM0_PG_URI=postgresql+psycopg2://mem0:${pg_pass}@127.0.0.1:5432/mem0|g" /etc/mem0/mem0.env
		else
			echo "MEM0_PG_URI=postgresql+psycopg2://mem0:${pg_pass}@127.0.0.1:5432/mem0" >> /etc/mem0/mem0.env
		fi
			
		ewarn "IMPORTANT: If you require Point-in-Time Recovery (PITR) for mem0,"
		ewarn "you must manually enable WAL archiving in your global postgresql.conf:"
		ewarn "  archive_mode = on"
		ewarn "  archive_command = 'cp %p /path/to/archive/%f'"
	fi
	
	if use neo4j; then
		einfo "Configuring Neo4j..."
		ewarn "Please ensure the APOC plugin is installed in your Neo4j plugins directory."
		ewarn "You must append the following to your neo4j.conf and restart the service:"
		ewarn "  dbms.security.procedures.unrestricted=apoc.*"
	fi
	
	if use qdrant; then
		einfo "Configuring Qdrant..."
		ewarn "Mem0 requires Qdrant to allow FUSE. Please ensure Qdrant is started with:"
		ewarn "  QDRANT__STORAGE__ALLOW_FUSE=true"
	fi
	
	if use redis; then
		einfo "Configuring Redis..."
		einfo "Updating /etc/mem0/mem0.env with default Redis URI..."
		if grep -q "^REDIS_URL=" /etc/mem0/mem0.env; then
			sed -i "s|^REDIS_URL=.*|REDIS_URL=redis://127.0.0.1:6379/0|g" /etc/mem0/mem0.env
		else
			echo "REDIS_URL=redis://127.0.0.1:6379/0" >> /etc/mem0/mem0.env
		fi
	fi

	einfo "Configuration complete. Review /etc/mem0/mem0.env and then:"
	einfo "  systemctl start mem0-api.service"
}
