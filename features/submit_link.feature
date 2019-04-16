@submit_link
#bundle exec cucumber --profile default --guess --tags @submit_link

Feature: Submit a link
  Submit a link in Hackers News

	Scenario: View welcome page
		When create a user with username "peteconsuegra" and pass "12345678"
		And create a link with title "WordPressPete" url "https://wordpresspete.com" description "WordPressPete is a local and production server environment that can be installed in macOS and Linux with just a few clicks."
		Then logout
		When create a user with username "waltdisney" and pass "12345678"
		And vote for the last published link
		And make a comment "Hello World 777"
		