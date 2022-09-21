package deepspace;

public interface SpaceFighter {
    // Realiza un disparo y se devuelve la energía o potencia del mismo.
    public float fire();
    
    // Se usa el escudo de protección y se devuelve la energía del mismo.
    public float protection();
    
    // Realiza las operaciones relacionadas con la recepción del impacto de 
    // un disparo enemigo. Devuelve el resultado de recivir el impacto.
    // @param float shot
    // @return ShotResult result
    public ShotResult receiveShot(float shot);
}
