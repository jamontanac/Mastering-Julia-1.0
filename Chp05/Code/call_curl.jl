using LibCURL

# init a curl handle
curl = curl_easy_init();

# set the URL and request to follow redirects
curl_easy_setopt(curl, CURLOPT_URL, "http://www.amisllp.uk")
curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1);

# setup the callback function to recv data
function curl_write_cb(curlbuf::Ptr{Nothing}, s::Csize_t, n::Csize_t, p_ctxt::Ptr{Nothing})
    sz = s * n
    data = Array{UInt8,1}(undef,sz)
    ccall(:memcpy, Ptr{Nothing}, (Ptr{Nothing}, Ptr{Nothing}, UInt64), data, curlbuf, sz)
    println("recd: ", String(data))
    sz::Csize_t
end

c_curl_write_cb = @cfunction curl_write_cb  Csize_t (Ptr{Nothing}, Csize_t, Csize_t, Ptr{Nothing});
curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, c_curl_write_cb);

# execute the query
res = curl_easy_perform(curl);
println("curl url exec response : ", res);

# retrieve HTTP code
http_code = Array{Clong,1}(undef,1);
curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, http_code);
println("httpcode : ", http_code);

# release handle
curl_easy_cleanup(curl);



