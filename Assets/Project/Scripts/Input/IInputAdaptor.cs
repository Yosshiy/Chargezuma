using UniRx;
using UnityEngine;

public interface IInputAdaptor
{
    IReadOnlyReactiveProperty<bool> OnJump { get; }
    IReadOnlyReactiveProperty<Vector3> OnMoveDirection { get; }
    
}
