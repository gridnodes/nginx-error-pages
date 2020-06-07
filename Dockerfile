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

# Use the jekyll image for building the error pages. This image also includes
# the tools required for downloading the dependencies, so no additional
# configuration is required.
FROM jekyll/jekyll

# Use a custom build directory, as the default one doesn't persist the data
# between individual build steps, because it's a Docker volume.
RUN mkdir /build && chown -R jekyll:jekyll /build
WORKDIR /build

# First, just copy the dependencies file into the build context and install them
# by using the yarn package manager. As this file rarely changes, this build
# step can be cached, even if other source files change more often.
COPY package.json /build
RUN  yarn install

# Copy all sources into the build context and generate the error pages.
COPY . /build
RUN  make build

# Alter permissions of the generated files, to just allow root writeable access
# and exclude especially nginx from writing into these files.
#
# NOTE: This step will be executed in the build environment to avoid an extra
#       layer in the final image.
RUN chown -R root:root /build/_site


# Build the final image.
#
# The final image just includes the generated error pages and necessary nginx
# configuration files for a minimal deployment.
#
# NOTE: This image is not able to run itself as container, as it doesn't include
#       any binary. It's intended to be copied into other images at build time
#       or to be mounted directly into other containers.
FROM scratch
COPY --from=0 /build/_site/ /nginx
