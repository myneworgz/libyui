
SOURCEDIR := src
MY_SRC := $(shell find $(SOURCEDIR) -name '*.cc')
MY_OBJ := $(patsubst %.cc,%.cc.o, $(MY_SRC))

CXX := c++
CC := cc

OS := $(shell uname)

CXXFLAGS := -std=c++14 -Wall -O3 \
	-fmessage-length=0 -pedantic -fPIE -fomit-frame-pointer -fwrapv \
	-Wshadow -Wformat=2 -Wno-format-nonliteral -Wpointer-arith -Wcast-qual -Wextra -Wno-unused-parameter -Woverloaded-virtual \
        -D VERSION='"3.3.3"'


#CXXFLAGS += -O0 -g3 -ggdb



ifeq ($(OS),Darwin)
	CXXFLAGS += -I/usr/local/include \
	-I/usr/local/Cellar/gettext/0.19.8.1/include/ \
	-Isrc/ 


	CXX := c++
        #CXX := /usr/local/Cellar/llvm/4.0.0_1/bin/clang++
	CC := cc
        #CC := /usr/local/Cellar/llvm/4.0.0_1/bin/clang
else
	CXX := g++
	CC := gcc
endif

LDFLAGS := -L/usr/local/lib/

ifeq ($(OS),Darwin)
	LDFLAGS +=  \
	-L/usr/local/Cellar/gettext/0.19.8.1/lib -lintl

else
	LDFLAGS += 

endif


all: link


curr: 



link: $(MY_OBJ)
	$(CXX) -dynamiclib -Wl,-headerpad_max_install_names -compatibility_version 8.0.0 -current_version 8.0.0 -o libyui.8.0.0.dylib \
		-install_name @rpath/libyui.8.dylib \
		$(MY_OBJ) -ldl $(LDFLAGS)


$(SOURCEDIR)/%.cc.o: $(SOURCEDIR)/%.cc
	$(CXX) $(CXXFLAGS) -c $< -o $@


%.cpp.o: $(SOURCEDIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@


%.c.o: $(SOURCEDIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@


#SampleClient: $(MY_OBJ) $(GEN_OBJ)
#	$(CXX) $^ -o $@ $(LDFLAGS) -lthrift


%.out: %.o
	$(CXX) $^ -o $@ $(LDFLAGS)




.PHONY: clean

.PRECIOUS: %.o %.pb.h %.pb.cc

clean:
	rm -rf src/*.cc.o *.dylib




