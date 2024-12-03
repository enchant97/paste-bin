-- name: InsertUser :one
INSERT INTO users (username) VALUES (?)
RETURNING id;

-- name: InsertPaste :one
INSERT INTO pastes (ownerId,slug) VALUES (?,?)
RETURNING id;

-- name: InsertPasteAttachment :one
INSERT INTO attachments (pasteId,slug) VALUES (?,?)
RETURNING id;

-- name: GetUserByUsername :one
SELECT * FROM users
WHERE username = ? LIMIT 1;

-- name: GetLatestPastes :many
SELECT * FROM pastes
ORDER BY id DESC;

-- name: GetLatestPastesByUser :many
SELECT pastes.* FROM pastes
INNER JOIN users ON users.id = pastes.ownerId
WHERE users.username = ?
ORDER BY pastes.id DESC;

-- name: GetPasteBySlug :one
SELECT pastes.* FROM pastes
INNER JOIN users ON users.id = pastes.ownerId
WHERE users.username = ? AND pastes.slug = ?
LIMIT 1;

-- name: GetAttachmentBySlug :one
SELECT attachments.* FROM attachments
INNER JOIN users ON users.id = pastes.ownerId
INNER JOIN pastes ON attachments.pasteId = pastes.id
WHERE users.username = ? AND pastes.slug = sqlc.arg(paste_slug) AND attachments.slug = sqlc.arg(attachment_slug)
LIMIT 1;