#
# Copyright (C) 2016 chentaov5@gmail.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Github: https://github.com/jllk	Blog: http://ct2wj.com
#

LOCAL_PATH = $(shell pwd)

SOURCE_DIR = $(LOCAL_PATH)/src

SOURCE_FILE = $(LOCAL_PATH)/srcfile

MANIFEST_FILE = $(LOCAL_PATH)/etc/manifest.txt

DEX_JAR = dx.jar

BAK_DEX_JAR = bak.dx.jar


all: clean install


build: createSourceFile
	$(info build)
	@javac -cp $(CLASSPATH) \@$(SOURCE_FILE)


createSourceFile: 
	$(info createSourceFile)
	$(shell find . -name "*.java" > $(SOURCE_FILE))


jar: build
	$(info jar)
	@jar cvfm $(DEX_JAR) $(MANIFEST_FILE) -C $(SOURCE_DIR) .


install: jar
	$(info install)
	@cp $(DEX_LIB_PATH)/$(DEX_JAR) $(DEX_LIB_PATH)/$(BAK_DEX_JAR) && \
	mv $(LOCAL_PATH)/$(DEX_JAR) $(DEX_LIB_PATH)/$(DEX_JAR)
	$(info install done.)


clean:
	$(info clean)
	@rm $(DEX_JAR) -rvf \
	rm $(SOURCE_FILE) -rvf \
	$(shell find . -name "*.class" | while read x; do rm $$x; done)




