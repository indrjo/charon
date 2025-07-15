.PHONY = clean uninstall
.RECIPEPREFIX = >

INSTALL_DIR = $(HOME)/.bin
CHARON      = $(INSTALL_DIR)/charon

$(CHARON): main.rkt charon.rkt system.rkt parser.rkt
> @[ -d $(INSTALL_DIR) ] || mkdir -p $(INSTALL_DIR)
> @(echo ":$(PATH):" | grep -q ":$(INSTALL_DIR):") || echo "$(INSTALL_DIR) not in PATH!"
> @raco exe -v -o $(CHARON) $<

clean:
> @rm -fr compiled

uninstall: clean
> @rm $(CHARON)

