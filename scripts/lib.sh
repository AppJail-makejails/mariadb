random_password()
{
	pwgen --numerals --capitalize --symbols --remove-chars="'\\" -1 32
}

escape_database_name()
{
    printf "%s\n" "$1" | sed -Ee 's/`/``/g'
}

escape_name()
{
    printf "%s\n" "$1" | sed -Ee "s/'/\\\\'/g"
}
