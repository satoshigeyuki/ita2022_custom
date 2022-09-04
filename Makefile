MASTER_DIR = masters
FORM_DIR = forms
TEST_DIR = tests
ANSWER_DIR = answers
RESULT_DIR = results

EXERCISES = $(basename $(notdir $(wildcard $(MASTER_DIR)/*.ipynb)))
MASTERS = $(addprefix $(MASTER_DIR)/, $(addsuffix .ipynb, $(EXERCISES)))
PREFILLS = $(addprefix $(MASTER_DIR)/, $(addsuffix .py, $(EXERCISES)))
ANSWERS = $(addprefix $(ANSWER_DIR)/, $(addsuffix .py, $(EXERCISES)))
TESTS = $(addprefix $(TEST_DIR)/, $(EXERCISES))

RESERVED = ex02_1 ex02_2 ex02_3 ex02_4 ex02_5 ex02_6 ex02_7 ex02_8 ex03_1 ex03_2 ex03_3 ex03_4 ex03_5 ex03_6 ex03_7 ex04_1 ex04_2 ex04_3 ex04_4 ex04_5 ex04_6 ex04_7 ex04_8 ex04_9 ex05_1 ex05_2 ex05_3 ex06_1 ex06_2 ex06_3 ex07_1 ex07_2 ex07_3 ex07_4 ex07_5 ex07_6 ex08_1 ex08_2 ex08_3 ex08_4

ifneq ($(filter $(RESERVED), $(EXERCISES)),)
$(error Conflict with reserved exercise names: $(filter $(RESERVED), $(EXERCISES)))
endif

all:	conf.zip

conf.zip:	$(MASTERS) $(PREFILLS) judge_env.json test_mod.json
	mkdir -p $(FORM_DIR)
	python3 plags_scripts/build_as_is.py -f $(FORM_DIR) -c judge_env.json -ag test_mod.json -bt plags_scripts/rawcheck_as_is.py -ac -qc $(MASTERS)

$(PREFILLS):
	touch $@

test_mod.json:	$(TESTS)
	python3 -c "import json,os,sys; print(json.dumps({os.path.basename(path): [os.path.join(path, x) for x in sorted(os.listdir(path)) if x.endswith('.py')] for path in sorted(sys.argv[1:])}, ensure_ascii=False, indent=4))" $(TESTS) > test_mod.json

$(TESTS):	$(wildcard $@/*.py)
	mkdir -p $@
	if [ $(words $(wildcard $@/*.py)) -ne 0 ]; then touch -r $$(ls -t $@/*.py | head -n 1) $@; fi

test:	test_mod.json answer_mod.json
	mkdir -p $(FORM_DIR).tmp $(RESULT_DIR)
	python3 plags_scripts/build_as_is.py -f $(FORM_DIR).tmp -ag test_mod.json -bt plags_scripts/rawcheck_as_is.py -ac answer_mod.json -qc -t $(RESULT_DIR) $(MASTERS)
	rm -fR $(FORM_DIR).tmp

answer_mod.json:	$(ANSWERS)
	python3 -c "import json,os,sys; print(json.dumps({os.path.basename(path)[:-3]: path for path in sorted(sys.argv[1:]) if path.endswith('.py')}, ensure_ascii=False, indent=4))" $(ANSWERS) > answer_mod.json

$(ANSWERS):
	mkdir -p $(ANSWER_DIR)
	touch $@

clean:
	rm -fR conf.zip conf test_mod.json answer_mod.json $(FORM_DIR) $(RESULT_DIR)

.PHONY: test clean
