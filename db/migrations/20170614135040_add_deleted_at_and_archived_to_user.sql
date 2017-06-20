-- +micrate Up
ALTER TABLE users ADD COLUMN deleted_at TIMESTAMP, ADD COLUMN archived BOOLEAN;

-- +micrate Down
ALTER TABLE users DROP COLUMN deleted_at TIMESTAMP, DROP COLUMN archived BOOLEAN;
