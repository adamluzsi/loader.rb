loader
======

Ruby require loader gem with caller tricks
Meta config file loaders and much more

### Introduction

Okey, before you even think about use this gem, let's say this gem only for lazy ones...
the basic idea is to have an easy to use relative require system with yaml config file loading
into a constant, maybe into some othere config specific gem that make config objects from hash.

The fun part is , that this stuffs can be used in making a new gem,
because it do not depend on the Dir.pwd or
the File Expand tricks

the use cases are hell simple , like:

    # return and load the meta files from
    # the lib/**/meta and return the hash obj build from the yamls
    Loader.meta

    # load all rb file that was not loaded already
    # from that relative folder
    require_relative_directory "folder_name"

