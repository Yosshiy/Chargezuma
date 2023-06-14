
using UnityEngine;
using UniRx;

public interface IInputAdaptor
{
    public void Initialize();
    public IReactiveProperty<Vector3> GetDirection { get; }
    public IReactiveProperty<bool> GetAction { get; }

}
