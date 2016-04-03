## NOTES about importing a CDR table from a production system for testing

Before any tests are run, read in the contents of a Gzipped compressed file containing a list of CDRs

- To grab a source file:

```bash
mysqldump -uroot -psome_password asteriskcdrdb | gzip -c | ssh deployer@testing.host.com 'cat > /home/deployer/dev/engines/free_pbx/spec/fixtures/asteriskcdrdb.sql.gz'
```

- To load it run:

```bash
gunzip < /home/deployer/dev/engines/free_pbx/spec/factories/asteriskcdrdb.sql.gz | mysql -uroot -psome_password free_pbx_test
```

- RSpec before code:
```ruby
    before(:all) do
      file_name = 'spec/fixtures/asteriskcdrdb.sql.gz'
      system "gunzip < #{file_name} | mysql -urails_mcp -prails_mcp free_pbx_test"
      @record_count = AsteriskCdr.count
    end
```
