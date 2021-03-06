if defined?(ActionMailer)
  class Devise::Mailer < Devise.parent_mailer.constantize
    include Devise::Mailers::Helpers

  default from: 'WCBN-FM Ann Arbor <radio@wcbn.org>'

    def confirmation_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :confirmation_instructions, opts)
    end

    def reset_password_instructions(record, token, opts={})
      @token = token
      if record.is_a?(Dj) && record.sign_in_count == 0
        @dj = record
        mail to: @dj.name_and_email, subject: "Your Readback account has been created!",
          template_name: 'readback_account_created'
      else
        devise_mail(record, :reset_password_instructions, opts)
      end
    end

    def unlock_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :unlock_instructions, opts)
    end
  end
end
