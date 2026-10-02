---
title: CWES Web-Fuzzing
icon: fas fa-file-certificate
order: 2
permalink: /certificates/cwes/web-fuzzing
image:
  path: banner.png
certificate: cwes
media_subpath: /assets/img/cwes
---

> **Methodology**:
>
> 
> *Web fuzzing is a technique used to discover hidden parts of a web application by sending many automated requests. The process involves gathering information about the target, choosing a suitable wordlist, fuzzing directories, files, or parameters, and analyzing the responses. Interesting results are then investigated manually to understand their purpose and behavior.*



## Directory and File Fuzzing (UPLOADED FORMS)

* We want to Fuzz nonvisible directores and files. (Unhide them)
* For this we utilize Wordlists, which will be SecLists or other Lists.


:::info
Pitchfork: Value 1 of Wordlist1 , with Value 1 of Wordlist 2

Clusterbomb: Value N x Value N of Wordlist 1 and 2, (All Combinations)

:::


`SecLists contains wordlists for:`

> * Common directory and file names
> * Backup files
> * Configuration files
> * Vulnerable scripts
> * And much more

Common used Wordlists in Seclists (Dir `Fuzzing`):

```bash
Discovery/Web-Content/common.txt
Discovery/Web-Content/DirBuster-2007_directory-list-2.3-medium.txtDiscovery/Web
Content/raft-large-directories.txt
Discovery/Web-Content/big.txt
```


### Tools for the Task


**FFUF** 


:::info
Fast web fuzzer for directories, files, and parameters.

:::

```bash
ffuf -u http://TARGET/FUZZ -w wordlist.txt 
ffuf -u http://TARGET/FUZZ -w wordlist.txt -e .php,.html,.txt,.bak,.js -v 
```

Recursive Fuzzing (Worse than Ferox)

```bash
ffuf -u http://TARGET/FUZZ -w wordlist.txt -recursion -recursion-depth 2 -rate 500
```

Proxy-usage 

```bash
ffuf -u http://TARGET/FUZZ -w wordlist.txt -x http://127.0.0.1:8080 
```

Fuzzing `**x-www-form-urlencoded**` 

```bash
ffuf -u http://IP/post.php -d "PARAMETER=FUZZ" -w /usr/share/wordlists/seclists/Discovery/Web-Content/big.txt -X POST -H "Content-Type: application/x-www-form-urlencoded" 
```

`**Multistyle**` fuzzing:

```bash
ffuf -u "http://TARGET/get.php?W1=W2" -w params.txt:W1 -w values.txt:W2 -mode clusterbomb
```

```bash
ffuf -u "http://TARGET/get.php?W1=W2" -w params.txt:W1 -w values.txt:W2 -mode pitchfork -fc 404
```

vhost fuzzing:

```bash
ffuf -u "http://TargetDomain/" -w wordlist.txt -H "Host: FUZZ.domain" -fs SIZE
```



| Flag | Description | Example Scenario |
|------|-------------|------------------|
| `-mc` (match code) | Include only responses that match the specified status codes. You can provide a single code, multiple codes separated by commas, or ranges of codes separated by hyphens (e.g., `200,204,301`, `400-499`). The default behavior is to match codes 200-299, 301, 302, 307, 401, 403, 405, and 500. | After fuzzing, you notice many 302 (Found) redirects, but you're primarily interested in 200 (OK) responses. Use `-mc 200` to isolate these. |
| `-fc` (filter code) | Exclude responses that match the specified status codes, using the same format as `-mc`. This is useful for removing common error codes like 404 Not Found. | A scan returns many 404 errors. Use `-fc 404` to remove them from the output. |
| `-fs` (filter size) | Exclude responses with a specific size or range of sizes. You can specify single sizes or ranges using hyphens (e.g., `-fs 0` for empty responses, `-fs 100-200` for responses between 100 and 200 bytes). | You suspect the interesting responses will be larger than 1KB. Use `-fs 0-1023` to filter out smaller responses. |
| `-ms` (match size) | Include only responses that match a specific size or range of sizes, using the same format as `-fs`. | You are looking for a backup file that you know is exactly 3456 bytes in size. Use `-ms 3456` to find it. |
| `-fw` (filter out number of words in response) | Exclude responses containing the specified number of words in the response. | You're filtering out a specific number of words from the responses. Use `-fw 219` to filter for responses containing that amount of words. |
| `-mw` (match word count) | Include only responses that have the specified amount of words in the response body. | You're looking for short, specific error messages. Use `-mw 5-10` to filter for responses with 5 to 10 words. |
| `-fl` (filter line) | Exclude responses with a specific number of lines or range of lines. For example, `-fl 5` will filter out responses with 5 lines. | You notice a pattern of 10-line error messages. Use `-fl 10` to filter them out. |
| `-ml` (match line count) | Include only responses that have the specified amount of lines in the response body. | You're looking for responses with a specific format, such as 20 lines. Use `-ml 20` to isolate them. |
| `-mt` (match time) | Include only responses that meet a specific time-to-first-byte (TTFB) condition. This is useful for identifying responses that are unusually slow or fast, potentially indicating interesting behavior. | The application responds slowly when processing certain inputs. Use `-mt >500` to find responses with a TTFB greater than 500 milliseconds. |


**Gobuster**


:::info
Fast Brutforcer written in Go, simple and easy to use

:::

```bash
gobuster dir -u http://TARGET -w wordlist.txt
gobuster dir -u http://TARGET:PORT -x extension1,2 -t THREADS -w wordlist.txt
```


:::info
Gobuster can Fuzz for VHOSTs and Brutforce DNS-based Subdomains

:::

**DNS Brutforcing:**

```bash
gobuster dns -d domain.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
```

Vhost Fuzz using Gobuster

```bash
gobuster vhost -u http://DOMAIN -w common.txt --append-domain
```

  
**Feroxbuster**


:::info
Recursive brutforce, good for reappending found dirs into List.

:::

```bash
feroxbuster -u http://TARGET -w wordlist.txt
```

Set request `timeout`

```bash
feroxbuster -u http://TARGET -w wordlist.txt --timeout s
```

Don't verify TLS `certificates`

```bash
feroxbuster -u https://TARGET -w wordlist.txt -k
```

Exclude status codes

```bash
feroxbuster -u http://TARGET -w wordlist.txt -C status_code
```

Filter by response `size`

```bash
feroxbuster -u http://TARGET -w wordlist.txt -S size
```

Filter by line count

```bash
feroxbuster -u http://TARGET -w wordlist.txt -N lines
```

Filter by word count 

```bash
feroxbuster -u http://TARGET -w wordlist.txt -W words_in_resp
```



**Wenum/WFuzz (ffuf does the same)**


:::info
Used for Fuzzing Parameters and Values/Input

:::

```bash
wenum -u http://TARGET/?param=FUZZ -w wordlist.txt
```



### Theory in Regards to fuzzing Bodyparameters and how to construct it:

> When a POST body carries form data, the Content-Type header tells the server how the bytes in the body are laid out. There are two encodings, and picking the wrong one for your fuzzing means the server never parses your parameter.

`application/x-www-form-urlencoded` 

* Body is one flat string of key=value pairs joined by & like moving them from the GET request into the body.
* Special characters are url-encoded
* Example body: username=admin&password=p%2Furmom
* Compact, no per-field metadata. Cannot carry raw binary/files. This is what curl -d and ffuf -d send by default, so it's the one you fuzz 95% of the time.


`multipart/form-data (used for file uploads or mixed text + files)`

The body is split into parts, each separated by a boundary we can dictate.

Each part has its own headers describing that one field, then a blank line, then the raw value:

```bash
Content-Type: multipart/form-data; boundary=----0xfzin #Last line of WebRequest

------0xfzin Content-Disposition: form-data; name="username"
admin 
------0xfzin Content-Disposition: form-data; name="avatar"; filename="pic.png" Content-Type: image/png
<raw binary bytes of the file> ------0xfzin--

closing has --
```


## Fuzzing Web APIs

> `REST` APIs utilize standard HTTP methods (GET, POST, PUT, DELETE) to perform CRUD (Create, Read, Update, Delete) operations on resources identified by unique URLs.

SOAP

> `SOAP` APIs follow a more formal and standardized protocol for exchanging structured information. They use XML to define messages, which are then encapsulated in SOAP envelopes and transmitted over network protocols like HTTP or SMTP. SOAP APIs often include built-in security, reliability, and transaction management features, making them suitable for enterprise-level applications requiring strict data integrity and error handling.
>
> 

```bash
Example query:
```

```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
   <soapenv:Header/>
   <soapenv:Body>
      <tem:GetStockPrice>
         <tem:StockName>AAPL</tem:StockName>
      </tem:GetStockPrice>
   </soapenv:Body>
</soapenv:Envelope>
```


GraphQL

> GraphQL is a relatively new query language and runtime for APIs. Unlike REST APIs, which expose multiple endpoints for different resources, GraphQL provides a single endpoint where clients can request the data they need using a flexible query language. This eliminates the problem of over-fetching or under-fetching data, which is common in REST APIs. GraphQL's strong typing and introspection capabilities make it easier to evolve APIs over time without breaking existing clients, making it a popular choice for modern web and mobile applications.

Example query:

```graphql
query {
  user(id: 123) {
    name
    email
  }
}
```


## Identifying API Endpoints

`Rest`:

> REST APIs are built around the concept of resources, which are identified by unique URLs called endpoints. These endpoints are the targets for client requests, and they often include parameters to provide additional context or control over the requested operation.

| Parameter Type | Description | Example |
|----------------|-------------|---------|
| Query Parameters | Appended to the endpoint URL after a question mark (`?`). Used for filtering, sorting, or pagination. | `/users?limit=10&sort=name` |
| Path Parameters | Embedded directly within the endpoint URL. Used to identify specific resources. | `/products/{id}pen_spark` |
| Request Body Parameters | Sent in the body of POST, PUT, or PATCH requests. Used to create or update resources. | `{ "name": "New Product", "price": 99.99 }` |


`Soap:`

> SOAP (Simple Object Access Protocol) APIs are structured differently from REST APIs. They rely on XML-based messages and Web Services Description Language (WSDL) files to define their interfaces and operations.

* Over one Endpoint
* Envelopes Body, determines which Operation
* Web Services Description Language WSDL


Imagine a SOAP API for a library that offers a book search service. The WSDL file might define an operation called `SearchBooks` with the following input parameters:

* `keywords` (string): The search terms to use.
* `author` (string): The name of the author (optional).
* `genre` (string): The genre of the book (optional).

Eample:

```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:lib="http://example.com/library">
   <soapenv:Header/>
   <soapenv:Body>
      <lib:SearchBooks>
         <lib:keywords>cybersecurity</lib:keywords>
         <lib:author>Dan Kaminsky</lib:author>
      </lib:SearchBooks>
   </soapenv:Body>
</soapenv:Envelope>
```

Discovering Soap Endpoints:

* `WSDL` Analysis: The WSDL file is the most valuable resource for understanding a SOAP API. It describes:
  * Available operations (endpoints)
  * Input parameters for each operation (message types, elements, and attributes)
  * Output parameters for each operation (response message types)
  * Data types used for parameters (e.g., strings, integers, complex types)
  * The location (URL) of the SOAP endpoint


`GraphQL`

> Queries are designed to fetch data from the GraphQL server. They pinpoint the exact fields, relationships, and nested objects the client desires, eliminating the issue of over-fetching or under-fetching data common in REST APIs.

| Component | Description | Example |
|-----------|-------------|---------|
| Field     | Represents a specific piece of data you want to retrieve (e.g., name, email). | `name`, `email` |
| Relationship | Indicates a connection between different types of data (e.g., a user's posts). | `posts` |
| Nested Object | A field that returns another object, allowing you to traverse deeper into the data graph. | `posts { title, body }` |
| Argument  | Modifies the behavior of a query or field (e.g., filtering, sorting, pagination). | `posts(limit: 5)` (retrieves the first 5 posts of a user) |

Example:

```graphql
query {
  user(id: 123) {
    name
    email
    posts(limit: 5) {
      title
      body
    }
  }
}
```

GraphQL `Mutations`

* Mutations are supposed to modify data on the server.
* Create, Update or Delete are encompassed within.

| Component | Description | Example |
|-----------|-------------|---------|
| Operation | The action to perform (e.g., createPost, updateUser, deleteComment). | `createPost` |
| Argument  | Input data required for the operation (e.g., title and body for a new post). | `title: "New Post", body: "This is the content of the new post"` |
| Selection | Fields you want to retrieve in the response after the mutation completes (e.g., id, title of new post). | `id`, `title` |

Example:

```graphql
mutation {
  createPost(title: "New Post", body: "This is the content of the new post") {
    id
    title
  }
}
```

We can retrieve API Endpoint information the following way:

> 
:::success
> Introspection: 
>
> GraphQL's introspection system is a powerful tool for discovery. By sending an introspection query to the GraphQL endpoint, you can retrieve a complete schema describing the API's capabilities.
>
> 
> :::

* Over the API Documentation itself
* Over Intercepting traffic, like with REST and SOAP based APIs


:::info
Remember, GraphQL is designed for flexibility, so there might not be a rigid set of queries and mutations. Focus on understanding the underlying schema and how clients can construct valid requests to retrieve or modify data.

:::


