package com.poslasticarnica.dto;

public class LoginZahtev {

    private String username;
    private String lozinka;

    public LoginZahtev() {}

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getLozinka() { return lozinka; }
    public void setLozinka(String lozinka) { this.lozinka = lozinka; }
}
