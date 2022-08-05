# filter

Replaces absolute URLs with prefixed ones

## Usage

```
filter --prefix /prefix/to/use <in >out
```

## Example

```
~ % filter --prefix /prefix <<'EOF'
heredoc> <html>
heredoc>   <head>
heredoc>     <title>Title</title>
heredoc>     <link rel="stylesheet" href="/style.css">
heredoc>   </head>
heredoc>   <body>
heredoc>     <h1>This is the header</h1>
heredoc>     <p>Wish to go <a src="/">home</a>?</p>
heredoc>   </body>
heredoc> </html>
heredoc> EOF
<html>
  <head>
    <title>Title</title>
    <link rel="stylesheet" href="/prefix/style.css">
  </head>
  <body>
    <h1>This is the header</h1>
    <p>Wish to go <a src="/prefix/">home</a>?</p>
  </body>
</html>
```
