# This file is part of nginx-error-pages.
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>.
#
#
# Copyright (C) 2020 mksec <support@mksec.de>

all: build


# ==========================
# Render additional graphics
# ==========================

svgs:                          \
	_includes/svgs/mark-ok.svg \
	_includes/svgs/mark-fail.svg

_includes/svgs/mark-ok.svg:                                          \
	node_modules/@fortawesome/fontawesome-free/svgs/solid/circle.svg \
	node_modules/@fortawesome/fontawesome-free/svgs/solid/check-circle.svg
	_includes/svgs/combine.sh solid/circle solid/check-circle > $@

_includes/svgs/mark-fail.svg:                                        \
	node_modules/@fortawesome/fontawesome-free/svgs/solid/circle.svg \
	node_modules/@fortawesome/fontawesome-free/svgs/solid/times-circle.svg
	_includes/svgs/combine.sh solid/circle solid/times-circle > $@


# =====
# build
# =====

build: svgs
	jekyll build -V

build-dev:
	docker build -t nginx-error-pages .
	docker create --name tmp-nginx-ep nginx-error-pages noop
	rm -rf build
	docker cp tmp-nginx-ep:/nginx build
	docker rm tmp-nginx-ep


# =======
# cleanup
# =======

clean:
	@rm -rf \
		_includes/svgs/*.svg \
		_site                \
		.jekyll-cache        \
		build
