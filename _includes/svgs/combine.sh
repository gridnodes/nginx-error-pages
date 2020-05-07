#!/bin/sh

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

##
# Get the path for a specific font awesome icon.
#
# @param $1 icon type and name separated by slash, e.g. 'solid/circle'
#
# @return the full path of the icon's SVG file
#
icon() {
    echo "node_modules/@fortawesome/fontawesome-free/svgs/$1.svg"
}


# The following script will concatenate two SVG files in a very simple fashion:
# The first SVG file will be printed without its closing SVG tag, before the
# second one's elements are printed. Finally, a closing SVG tag is printed, to
# complete the SVG file.
#
# NOTE: All line breaks except the final one will be truncated to reduce the
#       filesize and thus the resulting HTML file.
sed -e 's/<\/svg>//g' $(icon $1) | tr -d "\n"
xmllint --xpath "//*[name()='svg']/*" $(icon $2)
echo "</svg>"
