web: puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
release: rails db:migrate
