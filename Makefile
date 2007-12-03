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

IP=192.168.2.103
SRC=src/
IMG=img/

all:	Sudoku bundle

Sudoku:  main.o Sudoku.o ZBBoardView.o ZBCell.o SudokuController.o ZBNumberChooser.o
	$(LD) $(LDFLAGS) -o $@ $^

%.o:	$(SRC)%.m
		$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

bundle: Sudoku
	mkdir -p Sudoku.app/puzzles
	cp Sudoku Sudoku.app
	cp Info.plist Sudoku.app
	cp $(IMG)icon.png Sudoku.app
	cp $(IMG)Default.png Sudoku.app
	cp puzzles/*.txt Sudoku.app/puzzles/

deploy:
	scp -rp Sudoku.app root@$(IP):/Applications

zip: bundle
	zip -9yr Sudoku.zip Sudoku.app

clean:
	rm -f *.o Sudoku Sudoku.zip
	rm -Rf Sudoku.app

