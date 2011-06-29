CC=arm-apple-darwin-gcc -v
CXX=/usr/local/bin/arm-apple-darwin-g++

LD=$(CC)
LDFLAGS = -framework CoreFoundation \
          -framework Foundation \
          -framework UIKit \
          -framework LayerKit \
          -framework CoreGraphics \
          -framework GraphicsServices \
          -framework CoreSurface \
          -lobjc

IP=192.168.2.101
SRC=src/
IMG=img/

all:	Othello bundle

Othello:  main.o Othello.o ZBOthelloView.o ZBOthelloBoard.o ZBOthelloController.o ZBOthelloCell.o
	$(LD) $(LDFLAGS) -o $@ $^

%.o:	$(SRC)%.m
		$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

bundle: Othello
	mkdir -p Othello.app
	cp Othello Othello.app
	cp ${IMG}* Othello.app
	cp Info.plist Othello.app

deploy:
	scp -rp Othello.app root@$(IP):/Applications

zip: bundle
	zip -9yr Othello.zip Othello.app

clean:
	rm -f *.o Othello Othello.zip
	rm -Rf Othello.app

