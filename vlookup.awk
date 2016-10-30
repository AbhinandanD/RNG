FNR==NR{
  a[$1]=$2
  next
}
{ if ($1 in a) {print $1, a[$1], $2, a[$2]} else {print $1, "NA"}  }

