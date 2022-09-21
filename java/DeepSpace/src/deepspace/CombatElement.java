package deepspace;

public interface CombatElement {
    // Devuelve los usos restantes
    public int getUses();
    
    // Usa el elemento
    public float useIt();
}
