require 'openssl'
require 'base64'

def secret(auth, result="")
  key = auth[16..23]+auth[0..7]+auth[24..32]+auth[8..15]
  for e in key.chars do
    if e >= '0' and e <= '9'
        result += (((e[0]).ord - ('0').ord + 5) % 10 + ('0').ord).chr
    else
        result += (((e[0]).ord - ('a').ord + 9) % 26 + ('a').ord).chr
    end
  end
  return result
end

def encrypt(message, key)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = key
  cipher.iv = "\x00" * 16
  encrypted = cipher.update(message) + cipher.final
  return Base64.encode64(encrypted)
end

def decrypt(encrypted_message, key)
  decipher = OpenSSL::Cipher.new('AES-256-CBC')
  decipher.decrypt
  decipher.key = key
  decipher.iv = "\x00" * 16
  decoded_message = Base64.decode64(encrypted_message)
  return decipher.update(decoded_message) + decipher.final
end

message = "Hello Rubika :)"

auth = "zvwibgyirmmrkkoyrxdfmaoesfpuyxiv"
key = secret(auth)

encrypted_message = encrypt(message, key)
puts "Encrypted message: #{encrypted_message}"

decrypted_message = decrypt(encrypted_message, key)
puts "Decrypted message: #{decrypted_message}"

