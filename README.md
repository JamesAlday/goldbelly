# Goldbelly URL Shortener README

## General Disclaimer

This was the first time I've tried my hand at Ruby in quite a while, so please excuse how terrible I'm sure this all is. But this was actually a fun exercise - I was surprised at how fluent it all was.  I don't know all of the particulars, but it was easy to grok those I needed to in order to get this done. I didn't really add any bells or whistles to this project, it's a very simple API without a lot of validation or constraints.  This is in no way what I'd call a viable product, but is just a proof of concept for one.

I tried using the least amount of libraries possible just to keep the code simpler/cleaner but where I had the most trouble doing that was with testing, so I ended up following a few tutorials to get that working.  I've used RSpec for testing and the shoulda-matchers, factory_bot_rails, and database_cleaner libraries to manage test data.  The tests are all contained in the `urls_request_spec.rb` file, and could probably be a bit prettier and more thorough, but do some basic testing that data is being returned properly.


## Usage

Serve: `rails serve`
Test: `rspec`


### Response Codes
```
200: Success
204: No Content
500: Error
```

### Example Error Message
```json
http code 500
{
	"error": "Slug not found"
}
```

## API Methods

### Get All Shortened URLs

* Returns a list of all shortened URLs.  
* Not really practical for a live applicaiton, but good for debugging and testing of this little API and provides a view into the data model.
* I used a hard delete for the delete method, but provided a 'deleted_at' field with the intention of implementing 'soft deletes'.
* Also on the 'to add' short list would be some kind of pagination of the data

**Request:**
```json
GET /urls
Accept: application/json
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: ##

[
	{
		"id": 1,
		"long_url": "http://www.google.com",
		"slug": "google",
		"deleted_at": null,
		"created_at": "<datetime>",
		"updated_at": "<datetime>"
	},
	...
]
```

### Create Shortened URL

* The `slug` parameter below is optional.  If a create request is submitted without the parameter, a random shortened URL will be assigned.
* Random slugs are just an 8 character random string. This wouldn't hold up for very long and would be easy to reverse-engineer, so this part would definitely need more scrutiny. Consider this a placeholder for something real code would do.
* This does no data validation. I've set no boundaries on the slug length or type, which is asking for trouble, and the URL is not validated, so you could probably cram in some nasty JS in there for malware attacks, so not production ready? :|

**Request:**
```json
POST /urls
Accept: application/json
Content-Type: application/json
Content-Length: ##

{
	"long_url": "http://www.google.com",
	"slug": "google"
}
```

**Response**
```json
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: ##

{
    "id": 1,
    "long_url": "http://www.google.com",
    "slug": "google",
    "deleted_at": null,
    "created_at": "2020-08-08T19:43:00.187Z",
    "updated_at": "2020-08-08T19:43:00.187Z"
}
```

### Delete Shortened URL

* Does a simple delete of the record by slug
* Not implemented: soft deletes or expirations

**Request:**
```json
DELETE /urls
Accept: application/json
Content-Type: application/json
Content-Length: ##

{
	"slug": "google"
}
```

**Response**
```json
HTTP/1.1 204 No Content
```

### Redirect URL

* Does a simple redirect_to to the long_url for the record found by slug

**Request:**
```json
GET /urls/<slug>
```

**Response:**
```json
HTTP/1.1 302 found
Location: <long_url>
```