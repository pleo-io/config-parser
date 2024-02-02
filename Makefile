.ONESHELL:
SHELL = bash

start-infrastructure:
	docker compose up --build --detach

cleanup-infrastructure:
	docker compose down

test:
	docker compose exec validator bash validate.sh
