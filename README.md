# oai-mods-add-urls

This is a simple XSL stylesheet, a wrapping shell script, and some sample data. The XSL makes a couple of minor changes to a MODS file - removing one element and adding two.

## Testing
You can (probably) run this on a Unix-like system. You'll need xsltproc (somewhere under one of your bin directories, perhaps?) and bash.

```
$ ./mkxslmods.sh samples
```

And then check the output in `xsl-mods-samples`.