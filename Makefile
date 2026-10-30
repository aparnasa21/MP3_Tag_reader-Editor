CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -Iinc
SRC = src/main.c src/id3v1.c src/id3v2.c src/common.c
OBJ = $(SRC:.c=.o)
TARGET = mp3_tag_reader

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)

.PHONY: all clean
