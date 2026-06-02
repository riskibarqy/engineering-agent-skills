# Realistic Ticket Example

## Ticket

Add refund status filter to transaction report.

## Detected Files

- `internal/report/handler.go`
- `internal/report/export_handler.go`
- `internal/report/usecase.go`
- `internal/report/repository.go`
- `internal/report/repository_test.go`

## Current Behavior

Status filter currently supports `PAID`, `FAILED`, and `EXPIRED`.

## Evidence

- `internal/report/handler.go`: reads `status` query param for report list.
- `internal/report/export_handler.go`: reads `status` query param for CSV export.
- `internal/report/usecase.go`: maps public filter values to transaction statuses.
- `internal/report/repository.go`: builds `WHERE status IN (...)` clause.
- `internal/report/repository_test.go`: verifies SQL args for existing statuses.

## Architecture

Request flow: HTTP handler -> report usecase -> report repository -> DB query.

Status validation lives in usecase layer. SQL filtering lives in repository layer.

## Unknowns

- Whether `REFUND` means `FULL_REFUND` only or both `FULL_REFUND` and `PARTIAL_REFUND`.
- Whether `CHARGEBACK` should count as refund.
- Whether export endpoint must match list endpoint behavior.

## Questions

1. Should `REFUND` include `PARTIAL_REFUND`?
2. Should `REFUND` include `CHARGEBACK`?
3. Should export endpoint use same status mapping as list endpoint?
4. Should old saved reports preserve existing behavior?

## Plan If Questions Are Answered

1. Add public `REFUND` filter mapping in usecase layer.
2. Share mapping between list and export flows.
3. Update repository query expectations.
4. Add table-driven tests for refund mapping.
5. Run report package tests.

## Why Implementation Is Blocked

Ticket is vague. Multiple internal statuses could map to refund. Implementing now would invent business rules.
