all: mdclybu-sde3.zip

mdclybu-sde3.zip: sde3.pro sde3.log LICENSE
	zip $@ $^

SHA256: mdclybu-sde3.zip
	shasum -a 256 $^ > SHA256

.PHONY: check clean

check: mdclybu-sde3.zip
	shasum -c SHA256

clean:
	$(RM) mdclybu-sde3.zip
