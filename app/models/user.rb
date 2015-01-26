class User < ActiveRecord::Base

    self.primary_key = :user_id

    def self.authenticate(username, password)
      user = User.where(:username => username).first rescue nil
      if !user.blank?
        user.valid_password?(password) ? user : nil
      end
    end

    def valid_password?(password)
      return false if encrypted_password.blank?
      is_valid = Digest::SHA1.hexdigest("#{password}#{salt}") == encrypted_password	|| encrypt(password, salt) == encrypted_password || Digest::SHA512.hexdigest("#{password}#{salt}") == encrypted_password
    end

    def encrypted_password
      self.password
    end

    # Encrypts plain data with the salt.
    # Digest::SHA1.hexdigest("#{plain}#{salt}") would be equivalent to
    # MySQL SHA1 method, however OpenMRS uses a custom hex encoding which drops
    # Leading zeroes
    def encrypt(plain, salt)
      encoding = ""
      digest = Digest::SHA1.digest("#{plain}#{salt}")
      (0..digest.size-1).each{|i| encoding << digest[i].ord.to_s(16) }
      encoding
    end

    def self.encrypt(password,salt)
        Digest::SHA1.hexdigest(password+salt)
    end

end
