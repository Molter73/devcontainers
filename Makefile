build-%: %/
	make -C $* build

deploy-%: %/
	make -C $* deploy

teardown-%: %/
	make -C $* teardown
