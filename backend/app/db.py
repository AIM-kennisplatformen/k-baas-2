"""TypeDB database client and connection management."""

import logging
from typing import Any

from typedb.driver import (
    Credentials,
    Driver,
    DriverOptions,
    Transaction,
    TransactionType,
    TypeDB,
)

from app.config import get_settings

logger = logging.getLogger(__name__)


class TypeDBClient:
    """TypeDB client for database operations."""

    def __init__(self) -> None:
        """Initialize TypeDB client with settings."""
        settings = get_settings()
        self.db_name = settings.typedb_database_name
        self.address = settings.typedb_address
        self.username = settings.typedb_user_name
        self.password = settings.typedb_admin_password
        self.tls_enabled = settings.typedb_tls_enabled
        self.driver: Driver | None = None

    def connect(self) -> None:
        """Connect to TypeDB server."""
        if not self.driver:
            credentials = Credentials(self.username, self.password)
            self.driver = TypeDB.driver(
                self.address,
                credentials,
                DriverOptions(is_tls_enabled=self.tls_enabled),
            )
            logger.info("Connected to TypeDB at %s", self.address)

            # Ensure database exists
            if not self.driver.databases.contains(self.db_name):
                self.driver.databases.create(self.db_name)
                logger.info("Created database %s", self.db_name)

    def close(self) -> None:
        """Close TypeDB connection."""
        if self.driver:
            self.driver.close()
            self.driver = None
            logger.info("Disconnected from TypeDB")

    def execute_read_query(self, query: str) -> list[Any]:
        """Execute a read query and return results.

        Args:
            query: TypeQL read query to execute.

        Returns:
            List of query results.

        Raises:
            Exception: If connection fails or query errors.
        """
        if not self.driver:
            self.connect()

        if not self.driver:
            msg = "Could not connect to TypeDB"
            raise RuntimeError(msg)

        # Cast driver to Driver to satisfy type checker
        driver: Driver = self.driver

        results: list[Any] = []
        try:
            # Using driver.transaction directly as per inspection
            # Pylance incorrectly infers transaction as None, so we ignore the type error
            with driver.transaction(self.db_name, TransactionType.READ) as tx:  # type: ignore[union-attr]
                transaction: Transaction = tx  # type: ignore[assignment]
                # transaction.query returns a Promise, we must resolve it
                answer = transaction.query(query).resolve()

                if answer.is_concept_rows():
                    for row in answer.as_concept_rows():
                        row_data = {}
                        for col_name in row.column_names():
                            concept = row.get(col_name)
                            row_data[col_name] = str(concept)
                        results.append(row_data)
                elif answer.is_concept_documents():
                    for doc in answer.as_concept_documents():
                        results.append(str(doc))
                elif answer.is_ok():
                    results.append({"status": "OK"})

        except Exception:
            logger.exception("Error executing query")
            raise

        return results


# Global instance
_db_client: TypeDBClient | None = None


def get_db_client() -> TypeDBClient:
    """Get the global TypeDB client instance.

    Returns:
        TypeDBClient: The global database client.
    """
    global _db_client  # noqa: PLW0603
    if _db_client is None:
        _db_client = TypeDBClient()
    return _db_client
