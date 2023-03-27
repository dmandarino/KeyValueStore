# Transactional Key Value Store

This project is an interactive interface to a transactional key value store. Users can enter commands to set/get/delete key/value pairs and count values.
The interface should also allow the user to perform operations in transactions, which allows the user to commit or roll back their changes to the key value store. That includes the ability to nest transactions and roll back and commit within nested transactions.

```markdown
SET <key> <value> // store the value for key
GET <key>         // return the current value for key
DELETE <key>      // remove the entry for key
COUNT <value>     // return the number of keys that have the given value
BEGIN             // start a new transaction
COMMIT            // complete the current transaction
ROLLBACK          // revert to state prior to BEGIN call
```

## **Examples**

### Set and get a value:

```markdown
> SET foo 123
> GET foo
123
```

### Delete a value

```markdown
> DELETE foo
> GET foo
key not set
```

### Count the number of occurrences of a value

```markdown
> SET foo 123
> SET bar 456
> SET baz 123
> COUNT 123
2
> COUNT 456
1
```

### Commit a transaction

```markdown
> SET bar 123
> GET bar
123
> BEGIN
> SET foo 456
> GET bar
123
> DELETE bar
> COMMIT
> GET bar
key not set
> ROLLBACK
no transaction
> GET foo
456
```

### Rollback a transaction

```markdown
> SET foo 123
> SET bar abc
> BEGIN
> SET foo 456
> GET foo
456
> SET bar def
> GET bar
def
> ROLLBACK
> GET foo
123
> GET bar
abc
> COMMIT
no transaction
```

### Nested transactions
